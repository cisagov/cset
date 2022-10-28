import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MvraSummaryComponent } from './mvra-summary.component';

describe('MvraSummaryComponent', () => {
  let component: MvraSummaryComponent;
  let fixture: ComponentFixture<MvraSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MvraSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MvraSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
