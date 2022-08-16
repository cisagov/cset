import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-tutorial-edm',
  templateUrl: './tutorial-edm.component.html'
})
export class TutorialEdmComponent implements OnInit {

  /**
   * handsetPortrait
   */
  hp = false;

  constructor(
    public boSvc: BreakpointObserver
  ) { }

  ngOnInit(): void {
    this.boSvc.observe(Breakpoints.HandsetPortrait).subscribe(hp => {
      this.hp = hp.matches;
    });
  }

}
