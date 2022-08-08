import { NumberSymbol } from '@angular/common';
import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import SwiperCore, { SwiperOptions, Navigation, Pagination } from 'swiper';
SwiperCore.use([Navigation, Pagination]);
@Component({
  selector: 'app-new-assessment',
  templateUrl: './new-assessment.component.html',
  styleUrls: ['./new-assessment.component.scss']
})
export class NewAssessmentComponent implements OnInit, AfterViewInit {

  @ViewChild('swiper') swiper: any;

  hoverIndex = -1;
  tempArray=[,,,,,,,,];
  config: SwiperOptions = {
    slidesPerView: 3,
    spaceBetween: 10,
    slidesPerGroup: 2
  };
  constructor() { }

  ngOnInit(): void {
  }
  ngAfterViewInit(): void {
    console.log(this.swiper.swiperRef)
  }
  onSwiper([swiper]){
    console.log(this.swiper);
  }
  onSlideChange(){
    console.log('slide change')
  }
  onHover(i:number){
    this.hoverIndex = i;
  }
}
