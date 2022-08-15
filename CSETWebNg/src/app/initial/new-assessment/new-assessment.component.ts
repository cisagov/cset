import { Component, OnInit } from '@angular/core';
import { NavigationService } from '../../services/navigation/navigation.service';

@Component({
  selector: 'app-new-assessment',
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss']
})
export class NewAssessmentComponent implements OnInit {

  constructor(
    public navSvc: NavigationService
  ) { }

  ngOnInit(): void {


    /// DIAGNOSTIC CODE --------------------------------------
    for (let i = 0; i < 15; i++) {
      this.callTestAsync('async_task', 'Q');
      this.callTestAsync('regular', 'Q');
    }

    // for (let i = 0; i < 10; i++) {
    //   this.callTestAsync('regular', 'LONG');
    // }
    // for (let i = 0; i < 10; i++) {
    //   this.callTestAsync('regular', 'SHORT');
    // }


  }

  /// DIAGNOSTIC CODE --------------------------------------------
  callTestAsync(method: string, speed: string) {
    this.navSvc.callTestAsyncJson(method, speed).subscribe((resp: any) => {
      console.log(method + ' - ' + speed);
    });
  }

}
