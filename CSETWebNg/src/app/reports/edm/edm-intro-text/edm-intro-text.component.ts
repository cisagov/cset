import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-intro-text',
  templateUrl: './edm-intro-text.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmIntroTextComponent implements OnInit {

  orgName: string;

  constructor() { }

  ngOnInit(): void {
    this.orgName = "AXIS Chemical Industries";
  }

}
