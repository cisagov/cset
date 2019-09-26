import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../../services/diagram.service';

@Component({
  selector: 'zones',
  templateUrl: './zones.component.html',
  styleUrls: ['./zones.component.scss']
})
export class ZonesComponent implements OnInit {
  zones = [];
  displayedColumns = ['type', 'label', 'sal', 'layer', 'owner', 'visible']
  constructor(public diagramSvc: DiagramService) { }

  ngOnInit() {
    this.getZones();
  }

  getZones(){
    this.diagramSvc.getDiagramZones().subscribe((x:any) =>{
      this.zones = x;
      console.log(x);
    });
  }

  submit(zone){
    this.diagramSvc.saveZone(zone).subscribe((x:any)=>{
    
    });
  }
}
