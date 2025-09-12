import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-additional-observations',
  standalone: false,
  templateUrl: './additional-observations.component.html',
  styleUrl: './additional-observations.component.scss'
})
export class AdditionalObservationsComponent implements OnInit {

  ngOnInit(): void {
    console.log('additional observations!');
  }
}
