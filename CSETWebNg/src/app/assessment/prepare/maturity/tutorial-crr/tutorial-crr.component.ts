import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-tutorial-crr',
  templateUrl: './tutorial-crr.component.html'
})
export class TutorialCrrComponent implements OnInit {

  constructor(
    public configSvc: ConfigService
  ) { }

  ngOnInit(): void {
  }

}
