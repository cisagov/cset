import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AboutRraComponent } from './about-rra.component';

describe('AboutRraComponent', () => {
  let component: AboutRraComponent;
  let fixture: ComponentFixture<AboutRraComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AboutRraComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AboutRraComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
