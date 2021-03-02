import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { forEach } from 'lodash';
import { SetDetail } from '../../models/set-builder.model';
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
  warning: boolean;

  constructor(@Inject(MAT_DIALOG_DATA) public data: DialogData,
  public setSvc: SetBuilderService,
  public dialogRef: MatDialogRef<ModuleAddCloneComponent>
  ) {
    
  }

  selectedSets: SetDetail[] = [];
  setNames: SetDetail[];
  ngOnInit(): void {
    this.warning = false;
    this.setSvc.getBaseSetsList(this.data.setName).subscribe((selectedList: string[])=>{
    this.setSvc.getNonCustomSets(this.data.setName).subscribe((response: SetDetail[]) => {
      response.forEach(set => {
        if(selectedList.includes(set.SetName))
          this.selectedSets.push(set);
        else
          this.setNames.push(set);
      }
      );      
    },
    error =>
      console.log(
        "Unable to get Custom Standards: " +
        (<Error>error).message
      ));
      });
  }

  addSets(){
    console.log(this.selectedSets);
    this.setSvc.saveSets(this.data.setName,this.selectedSets).subscribe(()=>
    {
      this.warning = false;
      this.dialogRef.close();
    },
    error =>
      console.log("Unable to get Custom Standards: " +(<Error>error).message);
      this.warning=true;
    );
  }

}
