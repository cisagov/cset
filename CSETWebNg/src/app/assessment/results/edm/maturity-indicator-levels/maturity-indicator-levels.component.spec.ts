import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MaturityIndicatorLevelsComponent } from './maturity-indicator-levels.component';

describe('MaturityIndicatorLevelsComponent', () => {
  let component: MaturityIndicatorLevelsComponent;
  let fixture: ComponentFixture<MaturityIndicatorLevelsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MaturityIndicatorLevelsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MaturityIndicatorLevelsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
