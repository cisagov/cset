import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-cmmc-level-results',
  templateUrl: './cmmc-level-results.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcLevelResultsComponent implements OnInit {

  initialized = false;

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
  }

}
