import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RraSummaryComponent } from './rra-summary.component';

describe('RraSummaryComponent', () => {
  let component: RraSummaryComponent;
  let fixture: ComponentFixture<RraSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RraSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RraSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
