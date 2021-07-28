import { Component, Input, OnInit } from '@angular/core';
import { IRP } from '../../../../models/irp.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { IRPService } from '../../../../services/irp.service';

@Component({
  selector: 'app-irp-tabs',
  templateUrl: './irp-tabs.component.html',
  styleUrls: ['./irp-tabs.component.scss']
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
        return (this.irp.Comment && this.irp.Comment.length > 0) ? 'inline' : 'none';
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
