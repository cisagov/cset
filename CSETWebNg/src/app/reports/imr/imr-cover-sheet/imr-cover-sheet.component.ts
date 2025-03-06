import { Component, Input, OnInit } from '@angular/core';

@Component({
    selector: 'app-imr-cover-sheet',
    templateUrl: './imr-cover-sheet.component.html',
    styleUrls: ['./imr-cover-sheet.component.scss', '../imr-report/imr-report.component.scss'],
    standalone: false
})
export class ImrCoverSheetComponent implements OnInit {
  @Input()
  model: any;

  ngOnInit(): void {

  }
}
