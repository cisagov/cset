import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { SetBuilderService } from '../../services/set-builder.service';

export interface DialogData {
  setName:string;
}

@Component({
  selector: 'app-module-add-clone',
  templateUrl: './module-add-clone.component.html',
  styleUrls: ['./module-add-clone.component.scss']
})
export class ModuleAddCloneComponent implements OnInit {

  constructor(@Inject(MAT_DIALOG_DATA) public data: DialogData,
  public setSvc: SetBuilderService  
  ) {}

  setNames: string[];
  ngOnInit(): void {
    this.setSvc.getNonCustomSets(this.data.setName).subscribe(result => {
      console.log(result);
      if (result) {
        //this.setNames = result;
      }
    });
  }

}
