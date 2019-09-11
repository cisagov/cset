import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'text',
  templateUrl: './text.component.html',
  styleUrls: ['./text.component.scss']
})
export class TextComponent implements OnInit {
  dataSource = [];
  displayedColumns = ['label', 'layer']
  constructor() { }

  ngOnInit() {
  }

}
