import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-info-block',
  templateUrl: './info-block.component.html'
})
export class InfoBlockComponent implements OnInit {

  @Input()
  public response: any;

  ngOnInit() { }

}
