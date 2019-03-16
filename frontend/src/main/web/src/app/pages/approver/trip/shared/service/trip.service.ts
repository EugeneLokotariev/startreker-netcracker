import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

import { Api } from '../../../../../modules/api';
import { Trip } from '../model/trip.model';

@Injectable({
    providedIn: 'root'
})
export class TripService{

    constructor(private http: HttpClient){}

    public getTrips(status: String, offset: Number, limit: Number){
        let uri = Api.trip.trips() + '?status=' + status + '&offset=' + offset + '&limit=' + limit;
        return this.http.get(uri, {headers: this.createHeaders()});
    }

    public updateTripStatus(trip: Trip){
        let uri = Api.trip.update() + '/' + trip.trip_id;
        let updatedTrip = {
            trip_status: trip.trip_status
        };
        return this.http.patch(uri, updatedTrip, {headers: this.createHeaders()});
    }

    public updateTripReply(trip: Trip){
        let uri = Api.trip.update() + '/' + trip.trip_id;
        let updatedTrip = {
            trip_status: trip.trip_status,
            trip_reply: trip.trip_reply
        };
        return this.http.patch(uri, 
                                updatedTrip,
                                {headers: this.createHeaders()});
    }

    private createHeaders(){
        let headers = new HttpHeaders();
        headers = headers.append('Content-Type', 'application/json');
        headers = headers.append('Authorization', 'debug_login 3');
        return headers;
    }

    
}