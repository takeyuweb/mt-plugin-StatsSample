package StatsSample::Plugin;

use strict;
use MT;
use MT::Util;
use MT::Log;
use Time::Local qw(timegm);

our $plugin = MT->component( 'StatsSample' );

sub site_stats_widget_sample_condition {
    my $app = shift;
    my ( $param ) = @_;
    my $blog_id = $param->{blog_id};
    $plugin->get_config_value( 'enable', 'blog:' . $blog_id );
}

sub site_stats_widget_sample_lines {
    my $app = shift;
    my ( $from_tl, $param ) = @_;
    my $blog_id = $param->{blog_id};
    my $blog = MT->model( 'blog' )->load( $blog_id );
    my $from = timegm( @$from_tl );
    my $now = time;
    my @nowtl = MT::Util::offset_time_list( $now, $blog_id );
    my $today = timegm( 0, 0, 0, $nowtl[3], $nowtl[4], $nowtl[5] );
    my %counts;
    my $day = 24 * 60 * 60;
    for ( my $t = $from; $t < $today + $day; $t += $day ) {
        my @tl = gmtime( $t );
        my $date = sprintf( '%04d-%02d-%02d', $tl[5] + 1900, $tl[4] + 1, @tl[3] );
        my $terms = {
            blog_id => $blog_id,
            level   => MT::Log::ERROR(),
            created_on => [
                '-and',
                { op => '>', value => MT::Util::epoch2ts( $blog, $t ) },
                { op => '<', value => MT::Util::epoch2ts( $blog, $t + $day ) },
            ]
        };
        $counts{$date} = MT->model( 'log' )->count($terms);
    }
    
    return \%counts;
}

sub _cb_save_config_filter {
    my ( $cb, $plugin, $data, $scope ) = @_;
    my $app = MT->instance;
    my $blog = $app->blog or return 1;
    my $old_value = $plugin->get_config_value('enable', $scope) || 0;
    my $new_value = $data->{ 'enable' } || 0;
    if ( ref($old_value) eq 'ARRAY' ) {
        $old_value = $old_value->[0];
    }
    if ( ref($new_value) eq 'ARRAY' ) {
        $new_value = $new_value->[0];
    }
    if ( $old_value != $new_value ) {
        MT::Util::clear_site_stats_widget_cache( $blog->id, $app->user->id );
    }
    
    1;
}

1;
