import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';

@Component({
  selector: 'text',
  templateUrl: './text.component.html',
  styleUrls: ['./text.component.scss']
})
export class TextComponent implements OnInit {
  texts = [];
  displayedColumns = ['label', 'layer']
  constructor(public diagramSvc: DiagramService) { }

  ngOnInit() {
    this.getTexts();
  }

  getTexts(){
    this.diagramSvc.getDiagramText().subscribe((x:any) =>{
      this.texts = x;
    });
  }

  submit(text){
    this.diagramSvc.saveShape(text).subscribe((x:any)=>{});

  }

}
