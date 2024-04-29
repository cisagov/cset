import { AlertComponent } from './../../dialogs/alert/alert.component';
////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { SetDetail } from '../../models/set-builder.model';
import { MatDialog } from '@angular/material/dialog';
import { ModuleAddCloneComponent } from '../module-add-clone/module-add-clone.component';
import { OkayComponent } from '../../dialogs/okay/okay.component';

@Component({
  selector: 'app-set-detail',
  templateUrl: './set-detail.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class CustomSetComponent implements OnInit {

  setDetail: SetDetail = {};
  setDetailList: SetDetail[];

  submitted = false;

  /**
   *
   */
  constructor(public setBuilderSvc: SetBuilderService,
    public dialog: MatDialog) { }

  /**
   *
   */
  ngOnInit() {
    const setName = localStorage.getItem('setName');
    this.setBuilderSvc.getCustomSetList().subscribe(
      (response: SetDetail[]) => {
        this.setDetailList = response;
      }
    )
    this.setBuilderSvc.getSetDetail(setName).subscribe((response) => {
      this.setDetail = response;
      this.setDetail.categoryList.sort((a, b) => {
        if (a.categoryName < b.categoryName) {
          return -1;
        }
        if (a.categoryName > b.categoryName) {
          return 1;
        }
        return 0;
      })
      localStorage.setItem('setName', this.setDetail.setName);
    });
  }

  /**
   *
   */
  update(e) {
    console.log(e);
    if (this.setDetail.fullName?.length > 0 && e.target.id == 'fullname') {
      for (let s of this.setDetailList) {
        if (s.fullName == this.setDetail.fullName) {
          const msg2 = 'Module Name Already In Use';
          const titleComplete = 'Module Name'
          const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
          dlgOkay.componentInstance.hasHeader = true;
          this.setDetail.fullName = ""
        }
      }
    }
    if (this.setDetail.shortName?.length > 0 && e.target.id == 'shortname') {
      for (let s of this.setDetailList) {
        if (s.shortName == this.setDetail.shortName) {
          const msg2 = 'Short Name Already In Use';
          const titleComplete = 'Short Name'
          const dlgOkay = this.dialog.open(OkayComponent, { data: { title: titleComplete, messageText: msg2 } });
          dlgOkay.componentInstance.hasHeader = true;
          this.setDetail.shortName = ""
        }
      }
    }
    this.setBuilderSvc.updateSetDetails(this.setDetail).subscribe();
  }

  /**
   * Ideally this should ensure that the Description exists, but
   */
  isSetReady() {
    if (!this.setDetail) {
      return false;
    }
    if (!this.setDetail.setName) {
      return false;
    }

    if (!this.setDetail.fullName || this.setDetail.fullName.length === 0
      || !this.setDetail.shortName || this.setDetail.shortName.length === 0
      || !this.setDetail.description || this.setDetail.description.length === 0) {
      return false;
    }
    return true;
  }

  /**
   *
   */
  navReqList() {
    // validate
    this.submitted = true;
    if (!this.isSetReady()) {
      return;
    }

    this.setBuilderSvc.navReqList();
  }

  /**
   *
   */
  navQuestionList() {
    // validate
    this.submitted = true;
    if (!this.isSetReady()) {
      return;
    }

    this.setBuilderSvc.navQuestionList();
  }

  /**
   *
   */
  showSetClone() {
    let dialogRef = this.dialog.open(ModuleAddCloneComponent, {
      data: { setName: this.setDetail.setName }
    }).afterClosed().subscribe(result => {
      if (result) {
        this.dialog.open(AlertComponent, {
          data: {
            messageText: 'Module questions and requirements successfully cloned.',
            title: 'Success',
            iconClass: 'cset-icons-check-circle'
          }
        })
      }
    });
  }
}
