import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';

@Component({
  selector: 'app-tutorial-cmmc2',
  templateUrl: './tutorial-cmmc2.component.html'
})
export class TutorialCmmc2Component implements OnInit {

  /**
   * handsetPortrait
   */
  hp = false;

  constructor(
    public configSvc: ConfigService,
    public boSvc: BreakpointObserver
  ) { }

  ngOnInit(): void {
    this.boSvc.observe(Breakpoints.HandsetPortrait).subscribe(hp => {
      this.hp = hp.matches;
    });
  }

  documentURL(documentName: string) {
    return this.configSvc.docUrl + documentName;
  }
}
