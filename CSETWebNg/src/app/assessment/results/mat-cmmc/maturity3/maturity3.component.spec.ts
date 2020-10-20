import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Maturity3Component } from './maturity3.component';

describe('Maturity3Component', () => {
  let component: Maturity3Component;
  let fixture: ComponentFixture<Maturity3Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Maturity3Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Maturity3Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
