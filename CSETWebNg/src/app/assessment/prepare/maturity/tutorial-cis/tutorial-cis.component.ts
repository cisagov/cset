import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-tutorial-cis',
  templateUrl: './tutorial-cis.component.html'
})
export class TutorialCisComponent implements OnInit {

  constructor(
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
  }

}
