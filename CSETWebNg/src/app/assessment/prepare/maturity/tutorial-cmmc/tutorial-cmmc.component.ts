import { ConfigService } from './../../../../services/config.service';
import { Component, OnInit } from '@angular/core';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';

@Component({
  selector: 'app-tutorial-cmmc',
  templateUrl: './tutorial-cmmc.component.html',
  styleUrls: ['./tutorial-cmmc.component.scss']
})
export class TutorialCmmcComponent implements OnInit {

  /**
   * handsetPortrait
   */
   hp = false;

  constructor(
    public configSvc: ConfigService,
    public boSvc: BreakpointObserver
    ) { }

  documentURL(documentName: string) {
    return this.configSvc.docUrl + documentName;
  }

  ngOnInit(): void {
    this.boSvc.observe(Breakpoints.HandsetPortrait).subscribe(hp => {
      this.hp = hp.matches;
    });
  }

}
