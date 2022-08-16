import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';

@Component({
  selector: 'app-tutorial-cis',
  templateUrl: './tutorial-cis.component.html',
  styleUrls: ['./tutorial-cis.component.scss']
})
export class TutorialCisComponent implements OnInit {

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

}
