import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';

@Component({
  selector: 'components',
  templateUrl: './components.component.html',
  styleUrls: ['./components.component.scss']
})
export class ComponentsComponent implements OnInit {
  dataSource = [];
  displayedColumns = ['tag', 'hasUniqueQuestions', 'sal', 'criticality', 'layer', 'ipAddress', 'assetType', 'zone', 'subnetName', 'description', 'hostName', 'visible'];
  assetTypes: any;
  sal: any;
  criticality: any;
  constructor(public diagrmSvc: DiagramService) {

   }

  ngOnInit() {
    // Summary Percent Compliance
    this.diagrmSvc.getSymbols().subscribe((x:any) => {
      this.assetTypes = x;
    });

  }



}
