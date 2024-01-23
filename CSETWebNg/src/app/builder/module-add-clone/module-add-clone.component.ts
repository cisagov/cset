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
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { SetDetail } from '../../models/set-builder.model';
import { SetBuilderService } from '../../services/set-builder.service';

export interface DialogData {
  setName: string;
}

@Component({
  selector: 'app-module-add-clone',
  templateUrl: './module-add-clone.component.html',
  styleUrls: ['./module-add-clone.component.scss']
})
export class ModuleAddCloneComponent implements OnInit {
  warning: boolean = false;

  constructor(@Inject(MAT_DIALOG_DATA) public data: DialogData,
    public setSvc: SetBuilderService,
    public dialogRef: MatDialogRef<ModuleAddCloneComponent>
  ) {

  }

  selectedSets: SetDetail[] = [];
  setNames: SetDetail[] = [];

  /**
   *
   */
  ngOnInit(): void {
    const isName = (element) => element
    this.warning = false;
    this.setSvc.getBaseSetsList(this.data.setName).subscribe((selectedList: string[]) => {
      this.setSvc.getNonCustomSets(this.data.setName).subscribe((response: SetDetail[]) => {
        this.setNames = response;
        selectedList.forEach(x => {
          let index = this.setNames.findIndex((element: SetDetail) => { return element.setName == x; });
          if (index > -1)
            this.selectedSets.push(this.setNames[index]);
        });

      },
        error =>
          console.log(
            "Unable to get Custom Standards: " +
            (<Error>error).message
          ));
    });
  }

  /**
   *
   */
  addSets() {
    this.setSvc.saveSets(this.data.setName, this.selectedSets).subscribe(() => {
      this.warning = false;
      this.dialogRef.close(true);
    },
      error => {
        console.log("Unable to get Custom Standards: " + (<Error>error).message);
        this.warning = true;
      });
  }

  /**
   *
   */
  cancel() {
    this.dialogRef.close();
  }
}
