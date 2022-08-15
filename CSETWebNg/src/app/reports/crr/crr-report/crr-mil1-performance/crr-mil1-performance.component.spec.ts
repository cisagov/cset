import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrMil1PerformanceComponent } from './crr-mil1-performance.component';

describe('CrrMil1PerformanceComponent', () => {
  let component: CrrMil1PerformanceComponent;
  let fixture: ComponentFixture<CrrMil1PerformanceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrMil1PerformanceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrMil1PerformanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
