import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../../services/navigation.service';

@Component({
  selector: 'app-cmmc-compliance',
  templateUrl: './cmmc-compliance.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CmmcComplianceComponent implements OnInit {

  initialized = false;

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {
  }

}
