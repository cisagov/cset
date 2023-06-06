import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-hydro-action-item',
  templateUrl: './hydro-action-item.component.html',
  styleUrls: ['./hydro-action-item.component.scss']
})
export class HydroActionItemComponent implements OnInit {

  @Input() subCatName: any;
  @Input() impact: any;
  @Input() text: any;

  ngOnInit() {

  }
}
