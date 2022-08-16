
import { Component, OnInit } from '@angular/core';
import { LayoutService } from '../../../../services/layout.service';

@Component({
  selector: 'app-tutorial-edm',
  templateUrl: './tutorial-edm.component.html'
})
export class TutorialEdmComponent implements OnInit {


  constructor(
    public layoutSvc: LayoutService
  ) { }

  ngOnInit(): void {
  }

}
