export interface Details {
    name: string;
    weekly_hours: number;
    inserted_at: Date;
    updated_at: Date;
    id: number;
}

export interface User {
    email: string;
    confirmed_at?: any;
    id: number;
    inserted_at: Date;
    updated_at: Date;
    details: Details
}

export interface UserDetailsProps {
    details: Details;
    user: User;
}