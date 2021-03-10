import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-edm-intro-text',
  templateUrl: './edm-intro-text.component.html',
  styleUrls: ['../../reports.scss']
})
export class EdmIntroTextComponent implements OnInit {

  @Input()
  displayName: string;

  constructor() { }

  ngOnInit(): void {
  }
}
