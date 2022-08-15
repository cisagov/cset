import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrPercentageOfPracticesComponent } from './crr-percentage-of-practices.component';

describe('CrrPercentageOfPracticesComponent', () => {
  let component: CrrPercentageOfPracticesComponent;
  let fixture: ComponentFixture<CrrPercentageOfPracticesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrPercentageOfPracticesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrPercentageOfPracticesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
