import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-module-content-standard',
  templateUrl: './module-content-standard.component.html',
  styleUrls: ['./module-content-standard.component.scss']
})
export class ModuleContentStandardComponent implements OnInit {

  @Input()
  set: any;

  constructor() { }

  ngOnInit(): void {
  }

}
