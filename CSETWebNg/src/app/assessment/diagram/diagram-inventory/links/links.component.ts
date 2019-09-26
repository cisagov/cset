import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';

@Component({
  selector: 'links',
  templateUrl: './links.component.html',
  styleUrls: ['./links.component.scss']
})
export class LinksComponent implements OnInit {
  links = [];
  displayedColumns = ['label', 'subnetName', 'security', 'layer', 'headLineDecorator', 'tailLineDecorator', 'lineType', 'thickness', 'color', 'color', 'linkType', 'visible']
  constructor(public diagramSvc: DiagramService) { }

  ngOnInit() {
    this.getLinks();
  }

  getLinks(){
    this.diagramSvc.getDiagramLinks().subscribe((x:any) =>{
      this.links = x;
    });
  }

  submit(link){
    this.diagramSvc.saveLink(link).subscribe((x:any)=>{
    
    });

  }
}
