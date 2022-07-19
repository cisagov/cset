import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-guidance-block',
  templateUrl: './guidance-block.component.html',
  styleUrls: ['./guidance-block.component.scss']
})
export class GuidanceBlockComponent implements OnInit {

  @Input()
  supplementalInfo: string;

  constructor() { }

  ngOnInit(): void {
  }

}
