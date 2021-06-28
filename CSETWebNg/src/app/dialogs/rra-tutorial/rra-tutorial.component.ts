import { Component, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ConfigService } from '../../services/config.service';


/**
 * Presenting the RRA tutorial content in a dialog is 
 * a temporary solution to a full RRA User Guide.
 * 
 */
@Component({
  selector: 'app-rra-tutorial',
  templateUrl: './rra-tutorial.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class RraTutorialComponent {

  /**
   * Constructor.
   */
  constructor(
    private dialog: MatDialogRef<RraTutorialComponent>,
    public configSvc: ConfigService,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) { }

  close() {
    return this.dialog.close();
  }

}
