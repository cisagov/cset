import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-cmmc-level-drilldown',
  templateUrl: './cmmc-level-drilldown.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcLevelDrilldownComponent implements OnInit {

  initialized = false;

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
  }

}
