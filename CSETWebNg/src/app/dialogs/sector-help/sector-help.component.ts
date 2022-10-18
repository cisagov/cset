import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-sector-help',
  templateUrl: './sector-help.component.html'
})
export class SectorHelpComponent implements OnInit {

  sectors: any[];

  constructor(
    public dialogRef: MatDialogRef<SectorHelpComponent>,
    @Inject(MAT_DIALOG_DATA) public config: any
  ) { }

  ngOnInit(): void {
    this.sectors = this.config;
  }

  scrollTo(id: any) {
    (document.getElementById(id) as HTMLElement).scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
  }

  close(): void {
    this.dialogRef.close();
  }
}
