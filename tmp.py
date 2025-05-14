import os
import torch
from typing import Optional, Dict
from copy import deepcopy

import evaluate
from tqdm import tqdm
from termcolor import colored
import torch.optim as optim
from torch.utils.data import DataLoader
import monai
import kornia
import wandb


from segformer3d.config.config_loader import CONFIG
from segformer3d.metrics.segmentation_metrics import SlidingWindowInference

# The following trainers are DDP-Compliant


class Segmentation_Trainer:
    def __init__(
        self,
        checkpoint_dir: str,
        model: torch.nn.Module
    ) -> None:


    def _train_step(self) -> float:
        # Initialize the training loss for the current epoch
        epoch_avg_loss = 0.0

        # set model to train
        self.model.train()

        # set epoch to shift data order each epoch
        # self.train_dataloader.sampler.set_epoch(self.current_epoch)
        for index, raw_data in enumerate(self.train_dataloader):
            # add in gradient accumulation
            # TODO: test gradient accumulation
            with self.accelerator.accumulate(self.model):
                # get data ex: (data, target)
                data, labels = (
                    raw_data["image"],
                    raw_data["label"],
                )
                # print("data ", data.shape, "label ", labels.shape)

                # zero out existing gradients
                self.optimizer.zero_grad()

                # forward pass
                predicted = self.model.forward(data)

                # calculate loss
                loss = self.criterion(predicted, labels)

                # 

                # backward pass
                self.accelerator.backward(loss)

                # update gradients
                self.optimizer.step()

                # model update with ema if available
                if self.ema_enabled and (self.accelerator.is_main_process):
                    self.ema_model.update_parameters(self.model)

                # update loss
                epoch_avg_loss += loss.item()

                if self.print_every:
                    if index % self.print_every == 0:
                        self.accelerator.print(
                            f"epoch: {str(self.current_epoch).zfill(4)} -- "
                            f"train loss: {(epoch_avg_loss / (index + 1)):.5f} -- "
                            f"lr: {self.scheduler.get_last_lr()[0]}"
                        )

        epoch_avg_loss = epoch_avg_loss / (index + 1)

        return epoch_avg_loss

    def _val_step(self, use_ema: bool = False) -> float:
        """_summary_

        Args:
            use_ema (bool, optional): if use_ema runs validation with ema_model. Defaults to False.

        Returns:
            float: _description_
        """
        # Initialize the training loss for the current Epoch
        epoch_avg_loss = 0.0
        total_dice = 0.0

        # set model to train mode
        self.model.eval()
        if use_ema:
            self.val_ema_model.eval()

        # set epoch to shift data order each epoch
        # self.val_dataloader.sampler.set_epoch(self.current_epoch)
        with torch.no_grad():
            for index, (raw_data) in enumerate(self.val_dataloader):
                # get data ex: (data, target)
                data, labels = (
                    raw_data["image"],
                    raw_data["label"],
                )
                # forward pass
                if use_ema:
                    predicted = self.ema_model.forward(data)
                else:
                    predicted = self.model.forward(data)

                # calculate loss
                loss = self.criterion(predicted, labels)

                # calculate metrics
                if self.calculate_metrics:
                    mean_dice = self._calc_dice_metric(data, labels, use_ema)
                    # keep track of number of total correct
                    total_dice += mean_dice

                # update loss for the current batch
                epoch_avg_loss += loss.item()

        if use_ema:
            self.epoch_val_ema_dice = total_dice / float(index + 1)
        else:
            self.epoch_val_dice = total_dice / float(index + 1)

        epoch_avg_loss = epoch_avg_loss / float(index + 1)

        return epoch_avg_loss



    def _update_scheduler(self) -> None:
        pass


    # Train Wrapper
    def train(self) -> None:
        """
        Runs a full training and validation of the dataset.
        """
        self._run_train_val()
        self.accelerator.end_training()


