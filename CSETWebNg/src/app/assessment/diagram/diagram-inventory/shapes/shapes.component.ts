import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'shapes',
  templateUrl: './shapes.component.html',
  styleUrls: ['./shapes.component.scss']
})
export class ShapesComponent implements OnInit {
  shapes = [];
  displayedColumns = ['label', 'color', 'layer', 'visible']
  constructor() { }

  ngOnInit() {
  }

}
