import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';

@Component({
  selector: 'components',
  templateUrl: './components.component.html',
  styleUrls: ['./components.component.scss']
})
export class ComponentsComponent implements OnInit {
  components: any;
  displayedColumns = ['tag', 'hasUniqueQuestions', 'sal', 'criticality', 'layer', 'ipAddress', 'assetType', 'zone', 'subnetName', 'description', 'hostName', 'visible'];
  assetTypes: any;
  sal: any;
  criticality: any;
  constructor(public diagramSvc: DiagramService) {

   }

  ngOnInit() {
    // Summary Percent Compliance
    this.diagramSvc.getSymbols().subscribe((x:any) => {
      this.assetTypes = x;
    });
    this.getComponents();
  }

  getComponents(){
    this.diagramSvc.getDiagramComponents().subscribe((x:any) =>{
      this.components = x;
      console.log(x);
    });
  }

  submit(component){
    this.diagramSvc.saveDiagram(component).subscribe((x:any)=>{
    
    });

  }



}
