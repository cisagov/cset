import { Component } from '@angular/core';

@Component({
  selector: 'app-hydro-acronyms',
  templateUrl: './hydro-acronyms.component.html',
  styleUrls: ['./hydro-acronyms.component.scss']
})
export class HydroAcronymsComponent {

  acronyms: string[] = ['NREL', 'CVF', 'NIST', 'VaR'];
  names: string[] = ['National Renewable Energy Laboratory', 'Cybersecurity Value-at-Risk Framework'
                    , 'National Institute of Standards and Technology', 'Value at Risk'];
  assessmentInfo: any;

  loading: boolean = true;

  constructor(

  ) { }

}
