import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-mc-option',
  templateUrl: './mc-option.component.html',
  styleUrls: ['./mc-option.component.scss']
})
export class McOptionComponent implements OnInit {

  @Input()
  o: any;

  constructor() { }

  ngOnInit(): void {
  }

}
