import { Component } from '@angular/core';

@Component({
  selector: 'app-hydro-donut',
  templateUrl: './hydro-donut.component.html',
  styleUrls: ['./hydro-donut.component.scss']
})
export class HydroDonutComponent {

  colorScheme = {
    domain: ['#426A5A', '#7FB685', '#B4EDD2', '#D95D1E']
  };

  data: any[];
  view: any[] = [100, 100];

  ngOnInit(): void {



    // this.data = [
    //   {
    //     name: "Fully Implemented",
    //     value: this.questionDistribution.fi
    //   },
    //   {
    //     name: "Largely Implemented",
    //     value: this.questionDistribution.li
    //   },
    //   {
    //     name: "Partially Implemented",
    //     value: this.questionDistribution.pi
    //   },
    //   {
    //     name: "Not Implemented",
    //     value: this.questionDistribution.ni
    //   },
    //   {
    //     name: "Unanswered",
    //     value: this.questionDistribution.u
    //   },
    // ]

    // this.totalQuestionsCount = this.data.map(x => x.value).reduce((a, b) => a + b);
    // this.loading = false;

  }
}
