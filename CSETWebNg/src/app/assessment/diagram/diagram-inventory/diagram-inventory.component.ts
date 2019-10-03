import { Component, OnInit } from '@angular/core';
import { DiagramService } from '../../../services/diagram.service';
import {saveAs} from "file-saver";
import { Router } from '@angular/router';

@Component({
  selector: 'app-diagram-inventory',
  templateUrl: './diagram-inventory.component.html',
  styleUrls: ['./diagram-inventory.component.scss']
})
export class DiagramInventoryComponent implements OnInit {

  constructor(public diagramSvc: DiagramService, public router: Router) { }

  ngOnInit() {
  }

  getExport(){
    this.diagramSvc.getExport().subscribe(data => 
      saveAs(data, 'diagram-inventory-export.xlsx')),
      error => console.log('Error downloading file');
  }

  sendToDiagram() {
    this.router.navigateByUrl("/assessment/" + sessionStorage.getItem('assessmentId') + "/diagram/info");
}
}
