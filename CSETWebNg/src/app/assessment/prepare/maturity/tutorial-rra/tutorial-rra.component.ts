import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Component, Input, OnInit, ViewChild } from '@angular/core';

@Component({
  selector: 'app-tutorial-rra',
  templateUrl: './tutorial-rra.component.html'
})
export class TutorialRraComponent implements OnInit {

  /**
   * This is temporary.  It allows us to show this page content 
   * in a dialog launched from the help menu, but without displaying the Back and Next buttons.
   */
  @Input()
  showNav: boolean = true;

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
