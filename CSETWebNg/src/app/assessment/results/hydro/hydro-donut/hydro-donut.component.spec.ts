import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HydroDonutComponent } from './hydro-donut.component';

describe('HydroDonutComponent', () => {
  let component: HydroDonutComponent;
  let fixture: ComponentFixture<HydroDonutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HydroDonutComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HydroDonutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
