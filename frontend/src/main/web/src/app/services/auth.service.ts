import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Router, ActivatedRoute } from '@angular/router';
import { clone } from 'ramda';
import { Location } from '@angular/common';

import { Api, HttpOptions, HttpOptionsAuthorized } from '../modules/api';
import { LoginFormData } from './interfaces/login-form.interface';
import { RegisterFormData } from './interfaces/registration-form.interface';
import { RegisterResponse } from './interfaces/register-response.interface';
import { LoginResponse } from './interfaces/login-response.interface';

@Injectable({
  providedIn: 'root'
})

export class ApiUserService {
  // userData = {
  //   username: '',
  //   email: '',
  //   phone: '',
  //   authorities: []
  // }
  userData = {
    username: '',
    roles: []
  }

  constructor(
    private http: HttpClient,
    private router: Router,
    private activatedRoute: ActivatedRoute,
    private location: Location
    ) {}


    get userInfo() {
      return this.userData;
    }

    loginUser(userData: LoginFormData){
      return this.http.post<any>(Api.auth.loginUser(), userData, HttpOptions);
    }

    getLoggedUser(userData){
      this.setUserData(userData);
      localStorage.setItem('at', userData.access_token);
      localStorage.setItem('rt', userData.refresh_token);
    }

    public registerUser(userData: RegisterFormData){
      return this.http.post<any>(Api.auth.registerUser(), userData, HttpOptions)
    }

    public sendConfirmToken(params: HttpParams){
        return this.http.get(Api.auth.confirmPassword(), {headers: HttpOptions.headers,
                                                          params: params});
    }

    public logoutUser() {
      this.http.post<any>(Api.auth.logoutUser(), {}, HttpOptionsAuthorized);
      localStorage.removeItem('at');
      localStorage.removeItem('rt');
      localStorage.removeItem('userdata');
      this.userData = clone({});
      if(this.location.isCurrentPathEqualTo('/')){
        location.reload();
      }else{
        this.router.navigateByUrl('/');
      }
    }

    public recoverPassword(userData: any) {
      return this.http.post<any>(Api.auth.recoverPassword(), userData, HttpOptions);
    }

    setUserData(userData){
      this.userData = {username: userData.username,
                      roles: userData.roles}
      localStorage.setItem('userdata',JSON.stringify(this.userData));
    }
  }