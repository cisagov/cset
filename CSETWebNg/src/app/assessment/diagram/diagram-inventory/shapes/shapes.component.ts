import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';


@Component({
  selector: 'shapes',
  templateUrl: './shapes.component.html',
  styleUrls: ['./shapes.component.scss']
})
export class ShapesComponent implements OnInit {
  shapes = [];
  displayedColumns = ['label', 'color', 'layer', 'visible']
  constructor(public diagramSvc: DiagramService) { }

  ngOnInit() {
    this.getShapes();
  }

  getShapes(){
    this.diagramSvc.getDiagramShapes().subscribe((x:any) =>{
      this.shapes = x;
      console.log(x);
    });
  }

  
}
