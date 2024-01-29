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
import { Component, Input, OnInit } from '@angular/core';
import { IRP } from '../../../../models/irp.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { IRPService } from '../../../../services/irp.service';

@Component({
  selector: 'app-irp-tabs',
  templateUrl: './irp-tabs.component.html'
})
export class IrpTabsComponent implements OnInit {

  @Input() irp: IRP;

  expanded = false;
  mode: string; // selector for which data is being displayed, 'DETAIL', 'SUPP', 'CMNT'.

  constructor(
    public assessSvc: AssessmentService,
    private irpSvc: IRPService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {

  }

  /**
   * 
   * @param mode 
   */
  toggleExtras(clickedMode: string) {
    if (this.expanded && clickedMode === this.mode) {

      // hide
      this.expanded = false;
      this.mode = '';
      return;
    }

    this.expanded = true;
    this.mode = clickedMode;
  }

  /**
     * Returns a boolean indicating if there are comments on the risk.
     * @param mode
     */
  has(mode) {
    switch (mode) {
      case 'CMNT':
        return (this.irp.comment && this.irp.comment.length > 0) ? 'inline' : 'none';
    }
  }

  /**
   * Post the comment change to the API
   */
  submit(irpId, response, comment) {
    let i = new IRP(irpId, response, comment);

    this.irpSvc.postSelection(i).subscribe();
  }
}
